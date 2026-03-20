---
layout: default
title: Music Engineering Portfolio
---

# Music Engineering Portfolio

## Latest Projects

<ul>
{% for project in site.projects %}
  <li>
    <strong>{{ project.title }}</strong><br>
    {{ project.student_name }} — {{ project.category }}<br>
    {{ project.short_blurb }}
  </li>
{% endfor %}
</ul>
