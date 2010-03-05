class OddArchivePosts

  def initialize(path_prefix='', assign_to=:posts)
    @path_prefix = path_prefix
    @assign_to   = assign_to
  end

  def execute(site)
    posts = []

    site.pages.each do |page|
      if ( page.relative_source_path =~ /^#{@path_prefix}\/(20[01][0-9])-([01][0-9])-([0123][0-9])-([^.]+)\..*$/ )
        year  = $1
        month = $2
        day   = $3
        slug  = $4
        page.date = Time.utc( year.to_i, month.to_i, day.to_i )
        page.slug = slug
        context = OpenStruct.new({
          :site=>site,
          :page=>page,
        })
        #page.output_path = "#{@path_prefix}/#{year}/#{month}/#{day}/#{slug}.html"
        posts << page
      end
    end
    
    posts = posts.sort_by{|each| [each.date, File.mtime( each.source_path ), each.slug ] }.reverse
    
    last = nil
    singular = @assign_to.to_s.singularize
    posts.each do |e|
      if ( last != nil )
         e.send( "next_#{singular}=", last )
         last.send( "previous_#{singular}=", e )
      end
      last = e
    end
    
    site.send( "#{@assign_to}=", posts )
  end
end
