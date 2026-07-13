---
title: Books
icon: fas fa-book
order: 5
---

<style>
  .book-card {
    height: 100%;
    overflow: hidden;
    background-color: var(--card-bg);
    border-radius: 0.625rem;
    box-shadow: var(--card-shadow);
    transition: background-color 0.35s ease-in-out;
  }

  .book-card:hover {
    background-color: var(--card-hover-bg);
  }

  .book-cover,
  .book-cover-placeholder {
    width: 6.75rem;
    height: 10.125rem;
    background: var(--img-bg);
    border-radius: 0.625rem;
  }

  .book-cover-column {
    flex: 0 0 7.75rem;
  }

  .book-cover {
    box-sizing: border-box;
    padding: 0.375rem;
    object-fit: contain;
  }

  .book-cover-placeholder {
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--text-muted-color);
  }

  .book-card .card-title a {
    color: var(--heading-color);
  }

  .book-card .card-title a:hover {
    color: var(--link-color);
  }
</style>

<p>
  Books I have read, sourced from
  <a href="https://www.goodreads.com/user/show/151402161-luca-deuschel" rel="noopener noreferrer">my Goodreads profile</a>.
</p>

{% if site.data.goodreads_books and site.data.goodreads_books.size > 0 %}
<div class="row row-cols-1 row-cols-md-2 g-4">
  {% for book in site.data.goodreads_books %}
  <div class="col">
    <article class="book-card">
      <div class="row g-0 h-100">
        <div class="book-cover-column d-flex align-items-center justify-content-center p-2">
          {% if book.image_url %}
          <img
            src="{{ book.image_url | escape }}"
            class="book-cover rounded"
            alt="Cover of {{ book.title | escape }}"
          >
          {% else %}
          <div class="book-cover-placeholder">No cover</div>
          {% endif %}
        </div>
        <div class="col">
          <div class="card-body p-3">
            <h2 class="card-title fs-5">
              <a href="{{ book.link | escape }}" rel="noopener noreferrer" class="text-decoration-none">
                {{ book.title | escape }}
              </a>
            </h2>
            <p class="card-text text-muted"><small>{{ book.author | escape }}</small></p>
            {% if book.rating > 0 %}
            <p class="card-text mb-1" aria-label="Rated {{ book.rating }} out of 5 stars">
              {% for i in (1..5) %}
                {% if i <= book.rating %}
                <i class="fas fa-star text-warning" aria-hidden="true"></i>
                {% else %}
                <i class="far fa-star text-warning" aria-hidden="true"></i>
                {% endif %}
              {% endfor %}
            </p>
            {% endif %}
          </div>
        </div>
      </div>
    </article>
  </div>
  {% endfor %}
</div>
{% else %}
<p>My reading list is temporarily unavailable. You can still find it on Goodreads.</p>
{% endif %}
