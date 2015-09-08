(defrecord state
  cfg
  context
  socket)

(defrecord msg
  uuid
  (sep "<IDS|MSG>")
  baddad42
  header
  parent-header
  metadata
  content
  blob)