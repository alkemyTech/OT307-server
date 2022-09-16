class SnakeCaseFix < ActiveRecord::Migration[6.1]
  def change
    rename_column :members, :facebookUrl, :facebook_url
    rename_column :members, :instagramUrl, :instagram_url
    rename_column :members, :linkedinUrl, :linkedin_url
  end
end
