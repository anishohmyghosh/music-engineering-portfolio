---
layout: default
title: Music Engineering Portfolio
---

# Music Engineering Portfolio

## Latest Projects

<ul>
{% for project in site.projects %}
  <li>
    <a href="{{ project.url }}">
      <strong>{{ project.title }}</strong>
    </a><br>
    {{ project.student_name }} — {{ project.category }}<br>
    {{ project.short_blurb }}
  </li>
{% endfor %}
</ul>
