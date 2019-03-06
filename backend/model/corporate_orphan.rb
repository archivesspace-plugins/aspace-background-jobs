class AgentCorporateEntityOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      agent_corporate_entity.id,
      namece.sort_name,
      agent_corporate_entity.publish,
      agent_corporate_entity.created_by,
      agent_corporate_entity.last_modified_by,
      agent_corporate_entity.create_time,
      agent_corporate_entity.system_mtime,
      agent_corporate_entity.user_mtime,
      agent_corporate_entity.agent_sha1
    FROM
      orphans.agent_corporate_entity
    LEFT OUTER JOIN
      (select name_corporate_entity.* from orphans.name_corporate_entity)
      as namece
      on namece.agent_corporate_entity_id = agent_corporate_entity.id
  	LEFT OUTER JOIN
      linked_agents_rlshp
    ON
      agent_corporate_entity.id = linked_agents_rlshp.agent_corporate_entity_id
    WHERE
      linked_agents_rlshp.agent_corporate_entity_id
    IS
      null;"
  end

end
