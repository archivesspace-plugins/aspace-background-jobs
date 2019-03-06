class AgentFamilyOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      agent_family.id,
      namefam.sort_name,
      agent_family.publish,
      agent_family.created_by,
      agent_family.last_modified_by,
      agent_family.create_time,
      agent_family.system_mtime,
      agent_family.user_mtime,
      agent_family.agent_sha1
    FROM
      orphans.agent_family
    LEFT OUTER JOIN
      (select name_family.* from orphans.name_family)
      as namefam
      on namefam.agent_family_id = agent_family.id
  	LEFT OUTER JOIN
      linked_agents_rlshp
    ON
      agent_family.id = linked_agents_rlshp.agent_family_id
    WHERE
      linked_agents_rlshp.agent_family_id
    IS
      null;"
  end

end
