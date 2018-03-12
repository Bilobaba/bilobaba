# Constants used in the app, models, views, controllers, ... to avoid mistake with string

# Type of update for events with multi dates
UPDATE_TYPE_ONLY_ONE = "only one"
UPDATE_TYPE_ALL_AFTER = "all after"
UPDATE_TYPE_ALL_ITEMS = "all items"

# Action Supprimer
ACTION_SUPPRIMER = "Supprimer"

# type member
MEMBER_TYPE_AMATEUR = "1"
MEMBER_TYPE_PRO = "2"
MEMBER_TYPE = :member_type

# Sexe
MEMBER_GENDER_MALE = "Monsieur"
MEMBER_GENDER_FEMALE = "Madame"

# roles
ROLE_PROFESSIONAL = :professional
ROLE_AMATEUR = :amateur
ROLE_ADMIN = :admin

# booleans
YES = 'YES'
NO = 'NO'

# views data, avoid calculation big collection for every view call
VIEW_DATA_TOPICS = 'topics'
VIEW_DATA_MEMBERS = 'members'
