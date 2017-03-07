class ChangeLanguageIdToLanguage < ActiveRecord::Migration[5.0]
  def change
    rename_column :submissions, :language_id, :language
  end
end
