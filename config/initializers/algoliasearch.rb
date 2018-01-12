# Keys depend on ENV

# PROD works with account Algolia tao.zen.duy@gmail.com
# DEV works with account Algolia duy.dang@wanadoo.com
AlgoliaSearch.configuration = { application_id: ENV['ALGOLIA_SEARCH_APPLICATION_ID'], api_key: ENV['ALGOLIA_SEARCH_API_ADMIN_KEY'] }
