class AgentSoftwareOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      agent_software.id,
      namesw.sort_name,
      agent_software.publish,
      agent_software.created_by,
      agent_software.last_modified_by,
      agent_software.create_time,
      agent_software.system_mtime,
      agent_software.user_mtime,
      agent_software.agent_sha1
    FROM
      orphans.agent_software
    LEFT OUTER JOIN
      (select name_software.* from orphans.name_software)
      as namesw
      on namesw.agent_software_id = agent_software.id
  	LEFT OUTER JOIN
      linked_agents_rlshp
    ON
      agent_software.id = linked_agents_rlshp.agent_software_id
    WHERE
      linked_agents_rlshp.agent_software_id
    IS
      null;"
  end

end
