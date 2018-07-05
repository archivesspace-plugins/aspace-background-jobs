class FamilyOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      *
    FROM
      agent_family
    WHERE
      agent_family.id
    NOT IN
      (SELECT agent_family_id FROM linked_agents_rlshp);"
  end

end
