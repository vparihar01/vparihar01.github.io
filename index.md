---
layout: page
title: Rubyist love for Rails and Javascript!
description: My blog is on open source web development technologies (Ruby and their frameworks like Rails and Sinatra , PHP and its framework CAKE) and mobile technologies like Android . I have a deep passion for elegant design,cloud infrastructure(Rackspace and Amazon Web Services, AWS, S3, EC2) and their automation, distributed applications development, systems scaling, agile development methodologies, and experimental technologies.
tagline: Share and Care ;)
---

{% include JB/setup %}

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>


