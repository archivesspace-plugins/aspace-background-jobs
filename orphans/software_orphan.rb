class SoftwareOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      *
    FROM
      agent_software
    WHERE
      agent_software.id
    NOT IN
      (SELECT agent_software_id FROM linked_agents_rlshp);"
  end

end
