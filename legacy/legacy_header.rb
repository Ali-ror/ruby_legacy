class LegacyHeader < LegacyBase
  set_table_name "header"
  set_primary_key "id"

  def filename
    "#{self.id}.#{self.extension}"
  end
end
