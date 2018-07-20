class SubjectOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      *
    FROM
      subject
    WHERE
      subject.id
    NOT IN
      (SELECT subject_id FROM subject_rlshp)"
  end

end
