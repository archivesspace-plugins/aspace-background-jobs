class InstanceOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
        *
    FROM
        instance
    WHERE
        instance.id NOT IN (SELECT
                instance_id
            FROM
                instance_do_link_rlshp UNION ALL SELECT
                instance_id
            FROM
                sub_container);"
  end

end
