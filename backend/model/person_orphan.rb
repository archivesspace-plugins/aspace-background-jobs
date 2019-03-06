class AgentPersonOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      agent_person.id,
      namepers.sort_name,
      agent_person.publish,
      agent_person.created_by,
      agent_person.last_modified_by,
      agent_person.create_time,
      agent_person.system_mtime,
      agent_person.user_mtime,
      agent_person.agent_sha1
    FROM
      orphans.agent_person
    LEFT OUTER JOIN
      (select name_person.* from orphans.name_person)
      as namepers
      on namepers.agent_person_id = agent_person.id
  	LEFT OUTER JOIN
      linked_agents_rlshp
    ON
      agent_person.id = linked_agents_rlshp.agent_person_id
    WHERE
      linked_agents_rlshp.agent_person_id
    IS
      null;"
  end

end
