class AgentPersonOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
        agent_person.id,
        persname,
        agent_person.publish,
        agent_person.created_by,
        agent_person.last_modified_by,
        agent_person.create_time,
        agent_person.system_mtime,
        agent_person.user_mtime,
        agent_person.agent_sha1
    FROM
        agent_person
            LEFT OUTER JOIN
        (SELECT
            user.agent_record_id
        FROM
            user) AS userpers ON agent_person.id = userpers.agent_record_id
            LEFT OUTER JOIN
        (SELECT
            name_person.agent_person_id,
                MIN(name_person.sort_name) AS persname
        FROM
            name_person
        GROUP BY agent_person_id) AS namepers ON namepers.agent_person_id = agent_person.id
            LEFT OUTER JOIN
        linked_agents_rlshp ON agent_person.id = linked_agents_rlshp.agent_person_id
    WHERE
        linked_agents_rlshp.agent_person_id IS NULL
            AND userpers.agent_record_id IS NULL;"
  end

end
