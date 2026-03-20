---
layout: default
title: Music Engineering Portfolio
---

<h1>Music Engineering Portfolio</h1>

<div class="grid">
{% assign sorted = site.projects | sort: "publish_date" | reverse %}
{% for project in sorted %}
  <div class="card">
    <a href="{{ project.url | relative_url }}">
      <img src="{{ project.thumbnail_image | relative_url }}" alt="{{ project.title }}">
      <h3>{{ project.title }}</h3>
    </a>
    <p class="meta">
  {{ project.student_name }} • 
  <a href="{{ '/categories/' | append: project.category | slugify | relative_url }}">
    {{ project.category }}
  </a>
</p>
    <p>{{ project.short_blurb }}</p>
  </div>
{% endfor %}
</div>
