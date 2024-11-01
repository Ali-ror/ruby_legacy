class LegacyCategory < LegacyBase
  set_table_name 'setup_category'
  set_primary_key 'category_id'

  belongs_to :parent,
    :class_name  => 'LegacyCategory',
    :foreign_key => 'category_parent'

  has_many :children,
    :class_name  => 'LegacyCategory',
    :foreign_key => 'category_parent'

  scope :roots, where(:category_parent => 0)

  def each_depth_first
    yield self
    self.children.each do |child|
      child.each_depth_first do |c|
        yield c
      end
    end
  end

  def self_and_ancestors
    val = []
    p = self
    while !p.nil?
      val << p.category_name.strip
      p = p.parent
    end
    val.reverse
  end

end
