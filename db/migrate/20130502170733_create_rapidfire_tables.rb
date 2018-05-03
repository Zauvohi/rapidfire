if Rails::VERSION::MAJOR == 5
  version = [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join('.').to_f
  base = ActiveRecord::Migration[version]
else
  base = ActiveRecord::Migration
end

class CreateRapidfireTables < base
  def change
    create_table :rapidfire_surveys do |t|
      t.string  :name
      t.text :introduction
      t.timestamps
    end

    create_table :rapidfire_questions do |t|
      t.references :survey
      t.string  :type
      t.string  :question_text
      t.string  :default_text
      t.string  :placeholder
      t.integer :position
      t.text :answer_options
      t.text :validation_rules
      t.integer :parent_question_id
      t.integer :child_question_id

      t.timestamps
    end
    add_index :rapidfire_questions, :survey_id if Rails::VERSION::MAJOR != 5
    add_index :rapidfire_questions, :parent_question_id
    add_index :rapidfire_questions, :child_question_id

    create_table :rapidfire_attempts do |t|
      t.references :survey
      t.references :user, polymorphic: true

      t.timestamps
    end
    add_index :rapidfire_attempts, :survey_id if Rails::VERSION::MAJOR != 5
    add_index :rapidfire_attempts, [:user_id, :user_type]

    create_table :rapidfire_answers do |t|
      t.references :attempt
      t.references :question
      t.text :answer_text

      t.timestamps
    end
    if Rails::VERSION::MAJOR != 5
      add_index :rapidfire_answers, :attempt_id
      add_index :rapidfire_answers, :question_id
    end
  end
end
