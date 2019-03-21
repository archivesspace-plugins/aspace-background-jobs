# orphan_finder_job

An ArchivesSpace plugin that adds a background job to aid in identifying and remediating orphaned records.

## Record types included

- Archival objects
- Corporate Entities
- Families
- Instances
- Persons
- Software
- Subjects

Orphan records are identified by raw SQL queries so it is likely that additional record types could be added if desired with minimal work required.

## Job run types

### Test Run

During a test run, orphan records are identified and reported via the embedded job log.  No action is taken on these records.  This run type is useful when few orphaned records are identified and minimal manual review is required before deletion.

### Review Run

A review run is a test drive of the orphan finder that generates a downloadable `csv` providing select information about the orphaned records.  This run type is ideal for longer term or complex clean up projects when it is known that not all orphaned records are destined for deletion.

### Execute

This job identifies orphan records and immediately deletes them in bulk. This run type should be used when one is certain that *all* orphaned records should be permanently deleted. This operation is *not reversible*.

## To install:

1. Stop the application
2. Clone the plugin into the `archivesspace/plugins` directory
3. Add `orphan_finder_job` to `config.rb`, ensuring to uncomment/remove the # from the front of the relevant AppConfig line.  For example:
`AppConfig[:plugins] = ['local', 'orphan_finder_job']`
4. Restart the application
