class ArchivalObjectOrphan < AbstractOrphan

  register_orphan

  def query
    db.fetch(query_string)
  end

  def query_string
    "SELECT
        archival_object.id,
        archival_object.title,
        archival_object.repo_id,
        archival_object.publish,
        archival_object.suppressed,
        archival_object.ref_id,
        archival_object.component_id,
        archival_object.root_record_id,
        archival_object.parent_id,
        archival_object.parent_name,
        archival_object.created_by,
        archival_object.last_modified_by,
        archival_object.create_time,
        archival_object.system_mtime,
        archival_object.user_mtime
    FROM
        archival_object
    WHERE
        parent_name LIKE '%orphan%'
            AND repo_id = #{db.literal(@repo_id)};"
  end

end
