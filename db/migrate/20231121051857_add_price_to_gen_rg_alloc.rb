class AddPriceToGenRgAlloc < ActiveRecord::Migration[7.0]
  def change
    add_column :gen_rg_allocs, :price, :float
  end
end
