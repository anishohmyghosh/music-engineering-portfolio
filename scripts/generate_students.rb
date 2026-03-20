#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "fileutils"
require "date"

ROOT = File.expand_path("..", __dir__)
PROJECTS_DIR = File.join(ROOT, "_projects")
STUDENTS_DIR = File.join(ROOT, "students")

FileUtils.mkdir_p(STUDENTS_DIR)

# Read front matter from a markdown file
# Returns a Hash or nil when front matter is missing/invalid.
def read_front_matter(path)
  content = File.read(path)
  match = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  return nil unless match

  YAML.safe_load(match[1], permitted_classes: [Date], aliases: false) || {}
rescue StandardError
  nil
end

projects = Dir.glob(File.join(PROJECTS_DIR, "*.md"))
              .reject { |path| File.basename(path).start_with?("_") }

students = {}
projects.each do |project_path|
  data = read_front_matter(project_path)
  next unless data.is_a?(Hash)

  slug = data["student_slug"].to_s.strip
  name = data["student_name"].to_s.strip
  next if slug.empty?

  students[slug] ||= name.empty? ? slug.split("-").map(&:capitalize).join(" ") : name
end

students.each do |slug, name|
  output_path = File.join(STUDENTS_DIR, "#{slug}.md")
  file_contents = <<~MD
    ---
    layout: default
    title: "#{name}"
    permalink: /students/#{slug}
    student_name: "#{name}"
    student_slug: "#{slug}"
    ---

    <section class="stack">
      <p class="meta">Student Profile</p>
      <h1>{{ page.student_name }}</h1>
    </section>

    {% assign student_projects = site.projects | where: "student_slug", page.student_slug | sort: "publish_date" | reverse %}

    <section class="section stack">
      <h2>Projects</h2>
      <div class="grid">
      {% for project in student_projects %}
        <div class="card">
          <a class="card-media" href="{{ project.url | relative_url }}">
            <img src="{{ project.thumbnail_image | relative_url }}" alt="{{ project.title | escape }}">
          </a>
          <div class="card-body">
            <h3 class="card-title">
              <a href="{{ project.url | relative_url }}">{{ project.title }}</a>
            </h3>
            <p class="meta">
              {% assign cat_slug = project.category | slugify %}
              Project Type:
              <a href="{{ '/categories/' | append: cat_slug | relative_url }}">{{ project.category }}</a>
            </p>
            <p class="card-description">{{ project.short_blurb }}</p>
          </div>
        </div>
      {% endfor %}
      </div>

      {% if student_projects == empty %}
        <p class="meta">No projects available for this student yet.</p>
      {% endif %}

      <p class="meta"><a href="{{ '/students' | relative_url }}">← Back to Students</a> • <a href="{{ '/' | relative_url }}">Home</a></p>
    </section>
  MD

  File.write(output_path, file_contents)
end

# Remove stale generated pages that no longer map to a student slug.
existing_pages = Dir.glob(File.join(STUDENTS_DIR, "*.md"))
existing_pages.each do |page_path|
  slug = File.basename(page_path, ".md")
  next if slug == "index"
  next if students.key?(slug)

  File.delete(page_path)
end

puts "Generated #{students.size} student page(s)."
