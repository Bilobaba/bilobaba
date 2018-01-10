# Keys depend on ENV

if Rails.env == "development"
  # works with account Algolia duy.dang@wanadoo.fr
  AlgoliaSearch.configuration = { application_id: 'OMM51UN985', api_key: 'e762415cd24e8a478a9dc52464d2ca5e' }
else
  # works with account Algolia tao.zen.duy@gmail.com
  AlgoliaSearch.configuration = { application_id: ENV['ALGOLIASEARCH_APPLICATION_ID'], api_key: ENV['ALGOLIASEARCH_API_KEY'] }
end
