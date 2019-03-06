class SubjectOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
      subject.id,
      subject.title,
      subject.terms_sha1,
      subject.created_by,
      subject.last_modified_by,
      subject.create_time,
      subject.system_mtime,
      subject.user_mtime
    FROM
      subject
    WHERE
      subject.id
    NOT IN
      (SELECT subject_id FROM subject_rlshp)"
  end

end
