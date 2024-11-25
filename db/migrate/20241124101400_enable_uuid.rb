class EnableUuid < ActiveRecord::Migration[7.1]
  def up
    enable_extension 'pgcrypto'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The 'pgcrypto' extension cannot be disabled."
  end
end
