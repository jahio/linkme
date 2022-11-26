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
    add_index :links, [:url, :linktime, :token], unique: true, name: 'idx_links_are_unique'

    # These may not be strictly necessary but future reporting will definitely need this
    # so we might as well get it out of the way.
    add_index :links, :last_visit
    add_index :links, :visits
    add_index :links, :creator_ip
  end
end
