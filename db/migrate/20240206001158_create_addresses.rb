class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :name
      t.text :street
      t.text :city
      t.text :state
      t.text :zipcode

      t.timestamps
    end
  end
end
