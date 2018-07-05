class CorporateOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      *
    FROM
      agent_corporate_entity
    WHERE
      agent_corporate_entity.id
    NOT IN
      (SELECT agent_corporate_entity_id FROM linked_agents_rlshp);"
  end

end
