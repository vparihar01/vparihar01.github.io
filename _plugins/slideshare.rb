class SlideShare < Liquid::Tag
  Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/
 
  def initialize(tagName, markup, tokens)
    super
 
    if markup =~ Syntax then
      @id = $1
 
      if $2.nil? then
          @width = 560
          @height = 420
      else
          @width = $2.to_i
          @height = $3.to_i
      end
    else
      raise "No SlideShare ID provided in the \"slideshare\" tag"
    end
  end
 
  def render(context)
    # "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\"allowfullscreen></iframe>"
    # "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\">        </iframe>"
    a = "<iframe src=\"http://www.slideshare.net/slideshow/embed_code/#{@id}\" width=\"427\" height=\"356\" frameborder=\"0\"> </iframe>" 
    # b = "<div style=\"margin-bottom:5px\"> <strong> <a href=\"https://www.slideshare.net/vivekparihar1/mongodb-scalability-and-high-availability-with-replicaset\" title=\"MongoDb scalability and high availability with Replica-Set\" target=\"_blank\">MongoDb scalability and high availability with Replica-Set</a> </strong> from <strong><a href=\"http://www.slideshare.net/vivekparihar1\" target=\"_blank\">Vivek Parihar</a></strong> </div>"
    return a

  end
 
  Liquid::Template.register_tag "slideshare", self
end