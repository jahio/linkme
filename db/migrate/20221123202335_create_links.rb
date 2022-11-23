class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links, id: :uuid do |t|
      t.text            :url
      t.bigint          :linktime # "timestamp" may be a reserved word...
      t.text            :token
      t.bigint          :visits
      t.datetime        :last_visit
      t.text            :creator_ip
      # Thought about native data types in PG here but that could have unintended side
      # effects going forward (e.g. automagic/unexpected IP addr datatype/class conversion, etc.)
      # Best not to over-engineer it, leave it as a string and convert in future as needed.
      t.timestamps
    end

    # We need the combination of URL, linktime, and token to be unique,
    # and that name can get a bit too long potentially, so...
    add_index :links, [:url, :linktime, :token], unique: true, name: 'links_are_unique'

    # Create additional indices for faster lookup by singular granularity
    # TBH I'm not 100% certain if these are necessary for all databases or not with the above
    # index in place, but doing a lookup without ALL of the above columns in a query may
    # trigger a full table scan without each of these in the query otherwise, so to err on
    # the side of caution, here we go. Would prefer to discuss this with a DBA under ideal
    # circumstances.
    add_index :links, :url
    add_index :links, :linktime
    add_index :links, :token

    # These may not be strictly necessary but future reporting will definitely need this
    # so we might as well get it out of the way.
    add_index :links, :last_visit
    add_index :links, :visits
    add_index :links, :creator_ip
  end
end
