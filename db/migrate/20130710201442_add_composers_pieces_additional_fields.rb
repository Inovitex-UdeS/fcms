class AddComposersPiecesAdditionalFields < ActiveRecord::Migration
  def change
    # Composers
    remove_column :composers, :name
    add_column :composers, :last_name, :string, :null => false
    add_column :composers, :first_name, :string
    add_column :composers, :page_id, :integer, :unique => true

    # Pieces
    remove_column :pieces, :title
    add_column :pieces, :title, :string, :null => false
    add_column :pieces, :page_id, :integer, :unique => true
  end
end
