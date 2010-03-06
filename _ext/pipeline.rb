require 'odd_archive_posts'

Awestruct::Extensions::Pipeline.new do
  extension OddArchivePosts.new( '/posts' ) 
  extension Awestruct::Extensions::Paginator.new( :posts, '/posts/index', :per_page=>10 )
  extension Awestruct::Extensions::Indexifier.new
end

