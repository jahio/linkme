# link.me - a hypothetical URL shortener

## Setup

Assumes you have a modern and working development box for Ruby/Rails development,
and using [Homebrew](http://brew.sh) for MacOS. Adjust accordingly on other platforms/toolchains.

### Database

PostgreSQL. Create these two, as named below, on localhost. I used v15. My user for local development and test has permission for creating and dropping databases. That user is named, simply, `dev`. That user also has permission to `CREATE EXTENSION`, which will definitely also be needed in migrations.

- `CREATE DATABASE link_me_development OWNER dev;`
- `CREATE DATABASE link_me_test OWNER dev;`

### API

```
git clone <this repo> <somewhere on disk>
cd <where you cloned this repo>
bundle
alias be="bundle exec"
be rake db:migrate
be rake db:migrate RAILS_ENV=test
be rake spec
be rails s
```

That'll start the API server.

### Frontend

```
cd <this repo>/frontend
npm install
npm run serve
```

Now if you open a browser to the place it tells you in your terminal (should be localhost:8080), you should get a
minimal interface that allows you to create a link. **Requires JavaScript**. Uses Vue.js v3 on the front-end for an SPA.
I did this only as a "demo of capabilities", would probably not architect an app this way in the real world if I could avoid doing so,
but who really _can_ avoid JavaScript in 2022?

## RTFM

1. Fire up both the API and the frontend, then visit the frontend in a browser tab
1. Enter a valid URL in the box and hit enter
1. You'll be redirected to the overview page _at the URL shortener_ that will describe/warn you where you're about to be redirected. After 5 seconds, said redirection will take place via JS.

I did it this way so that the end user gets a "fair warning" should they get sent a link to a malicious website/domain via link shortner at some point. If you're tired of
being rickrolled, this one's for you.

## Discussion

There are a few different approaches that could be tried here. Each has pros and cons.

1. Random string tokens
2. Use integers for primary keys and encode/decode the URL based on those IDs

### Random String Tokens

The problem inherent with this approach is collision. Sure, you could just use some kind of
`while...do` loop to continually retry until you get a unique string, or rely on database
indices for uniqueness, throw an error when the insertion fails, then use application code
to catch the error and re-try, but then you have another problem: the larger the system
grows, the fewer URLs you can store until one day you hit an absolute hard cap and have
nowhere to go but increasing the length of the URL string by N characters, thus eventually
defeating the point of a URL shortener entirely.

Plus, the whole "yeah I know it's going to break during runtime execution so I'll build the
fix right in that same execution logic" thing seems a bit iffy. Unnecessarily complex by
(lazy?) design. Lots of error correcting going on there. More elegant approach possible?

### Integers as primary keys -> encoding function -> URL

Another approach would be to use integers as primary keys in the database (this is already
a red flag for me, operations wise, but we'll let it slide for a moment), run that through
some form of encoding or decoding function, and then let that be how we arrive at the URL
or shortened URL as desired. Enter the shortened URL, decode, and boom, there's your primary
key.

The thing I like about this is that it's backed by _math_. What I don't like about it, though,
is using integers as your primary key in the database. I've seen this in production scenarios
in both MySQL and PostgreSQL and it's prone to operations nightmares once you hit a certain
scale. There are some caveats with this that some developers aren't aware of:

- Say you use an int today only to delete that row tomorrow. Do you get to re-use that ID later? NOPE!
- What happens when you run out of integers for primary keys - when you hit the ceiling?
  - That table stops accepting any more insertions, you can't have any more data in there, ever!

This is why, unless I know for certain the data in the table is going to be inherently limited
somehow, I always opt for UUIDs. But, doing a string to string encoding doesn't quite make
any sense in this context, and we're still going to have the mathematical limitations inherent
within the nature of a **shortened** URL at play here, preventing us from growing that URL too
much. So encoding based on UUIDs is definitely out.

That's why I came up with a third option, a twist on the first. Option three:

### Encoding based on UNIX timestamp coupled with randomized token for collisions

This way we get around the integers vs. UUIDs problem (we get to use UUIDs) and we can severely
restrain the probability of URL encoding collision based on _time_ of submission since we can encode
on UNIX timestamp. But, it is certainly possible for a collision to occur on this model, which is why
I've added the additional protection of a randomized token on the end of the shortened URL. This makes
it near mathematically impossible for a submission of collision to occur, keeps URLs short and transmissible,
and allows the future expansion opportunity of paths and additional tokens affixed on the end should they
one day become necessary for any reason.

A pseudo-table (incomplete) for that may look something like this:

| UUID | Link | UNIX Timestamp | Token | Visits | Last Visit | Creator IP |
| ---- | ---- | -------------- | ----- | ------ | ---------- | ---------- |
| .... | .... | 16692339002274 | A4f2  | 123456 | 1669227659 | 127.0.0.1  |

Where the timestamp is derived from:

```ruby
t = (Time.now.to_f * 10000).round
```

For the sake of accuracy/collision reduction.

So that may result in a URL like...

http://example.tld/anU2F2b.A4f2

...or something.
