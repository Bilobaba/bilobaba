class AddPublishedToTestimonials < ActiveRecord::Migration[5.1]
  def change
    add_column :testimonials, :published, :boolean
  end
end
