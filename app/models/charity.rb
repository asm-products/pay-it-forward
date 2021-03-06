class Charity < ActiveRecord::Base
  validates :name, presence: true

  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: 'http://placehold.it/300x300'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
