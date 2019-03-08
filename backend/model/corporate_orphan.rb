class AgentCorporateEntityOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
        agent_corporate_entity.id,
        cename,
        agent_corporate_entity.publish,
        agent_corporate_entity.created_by,
        agent_corporate_entity.last_modified_by,
        agent_corporate_entity.create_time,
        agent_corporate_entity.system_mtime,
        agent_corporate_entity.user_mtime,
        agent_corporate_entity.agent_sha1
    FROM
        agent_corporate_entity
            LEFT OUTER JOIN
        (SELECT
            repository.agent_representation_id
        FROM
            repository) AS repoce ON agent_corporate_entity.id = repoce.agent_representation_id
            LEFT OUTER JOIN
        (SELECT
            name_corporate_entity.agent_corporate_entity_id,
                MIN(name_corporate_entity.sort_name) AS cename
        FROM
            name_corporate_entity
        GROUP BY agent_corporate_entity_id) AS namece ON namece.agent_corporate_entity_id = agent_corporate_entity.id
            LEFT OUTER JOIN
        linked_agents_rlshp ON agent_corporate_entity.id = linked_agents_rlshp.agent_corporate_entity_id
    WHERE
        linked_agents_rlshp.agent_corporate_entity_id IS NULL
            AND repoce.agent_representation_id IS NULL;"
  end

end
