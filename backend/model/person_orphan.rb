class PersonOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      *
    FROM
      agent_person
    WHERE
      agent_person.id
    NOT IN
      (SELECT agent_person_id FROM linked_agents_rlshp);"
  end

end
