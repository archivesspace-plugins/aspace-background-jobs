class ArchivalObjectOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      *
    FROM
      archival_object
    WHERE
      parent_name
    LIKE
      '%orphan%';"
  end

end
