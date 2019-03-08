class AgentFamilyOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
        agent_family.id,
        famname,
        agent_family.publish,
        agent_family.created_by,
        agent_family.last_modified_by,
        agent_family.create_time,
        agent_family.system_mtime,
        agent_family.user_mtime,
        agent_family.agent_sha1
    FROM
        agent_family
            LEFT OUTER JOIN
        (SELECT
            name_family.agent_family_id,
                MIN(name_family.sort_name) AS famname
        FROM
            name_family
        GROUP BY agent_family_id) AS namefam ON namefam.agent_family_id = agent_family.id
            LEFT OUTER JOIN
        linked_agents_rlshp ON agent_family.id = linked_agents_rlshp.agent_family_id
    WHERE
        linked_agents_rlshp.agent_family_id IS NULL;"
  end

end
