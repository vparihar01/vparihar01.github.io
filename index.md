---
layout: page
title: Rubyist love for Rails and Javascript!
description: My blog is on open source web development technologies (Ruby and their frameworks like Rails and Sinatra , PHP and its framework CAKE) and mobile technologies like Android . I have a deep passion for elegant design,cloud infrastructure(Rackspace and Amazon Web Services, AWS, S3, EC2) and their automation, distributed applications development, systems scaling, agile development methodologies, and experimental technologies.
tagline: Share and Care ;)
---

{% include JB/setup %}

<table class="table table-hover table-bordered">
 <thead>
    <tr>
      <th>Title</th>
      <th>Posted On</th>
    </tr>
  </thead>
  {% for post in site.posts %}
     <tbody>
        <tr>
          <td><a class="span8" href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></td>
          <td>{{ post.date | date_to_string }}</td>
        </tr>
      </tbody>
  {% endfor %}
</table>


