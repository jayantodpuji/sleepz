// DOM Elements
const tabClockIn = document.getElementById("tab-clock-in");
const tabFollow = document.getElementById("tab-follow");
const tabTimeline = document.getElementById("tab-timeline");

const menuClockIn = document.getElementById("menu-clock-in");
const menuFollow = document.getElementById("menu-follow");
const menuTimeline = document.getElementById("menu-timeline");

const clockInUser = document.getElementById("clockInUser");
const clockInAction = document.getElementById("clockInAction");
const clockInTableBody = document.getElementById("clockInTableBody");

const followUser = document.getElementById("followUser");
const followTarget = document.getElementById("followTarget");

const timelineUser = document.getElementById("timelineUser");
const timelineContent = document.getElementById("timelineContent");
const loadTimelineButton = document.getElementById("loadTimeline");
const loadMoreTimelineButton = document.getElementById("loadMoreTimeline");

// Variables
let selectedTimelineUser = null;
let timelinePage = 1;

// Utility Functions
function switchMenu(activeMenu) {
  menuClockIn.classList.add("is-hidden");
  menuFollow.classList.add("is-hidden");
  menuTimeline.classList.add("is-hidden");
  activeMenu.classList.remove("is-hidden");
}

function populateOptions(selectElement, data) {
  selectElement.innerHTML = data
    .map((item) => `<option value="${item.value}">${item.label}</option>`)
    .join("");
}

// Event Listeners
tabClockIn.addEventListener("click", () => switchMenu(menuClockIn));
tabFollow.addEventListener("click", () => switchMenu(menuFollow));
tabTimeline.addEventListener("click", () => switchMenu(menuTimeline));

document.getElementById("submitClockIn").addEventListener("click", () => {
  const user_id = clockInUser.value;
  const user_action = clockInAction.value;
  const user_action_time = new Date().toISOString(); // Current time in ISO 8601 format

  fetch("http://localhost:3000/api/v1/user_actions", {
    method: "POST",
    body: JSON.stringify({ user_id, user_action, user_action_time }),
    headers: { "Content-Type": "application/json" },
  })
    .then(response => {
      if (!response.ok) {
        return response.json().then(err => Promise.reject(err));
      }
      return response.json();
    })
    .then((response) => {
      clockInTableBody.innerHTML = response.data
        .map(
          (item, index) =>
            `<tr>
              <td>${index + 1}</td>
              <td>${item.attributes.action}</td>
              <td>${new Date(item.attributes.action_time).toLocaleString()}</td>
            </tr>`
        )
        .join("");
    })
    .catch(error => {
      const errorBox = document.createElement('div');
      errorBox.className = 'notification is-danger is-light';
      errorBox.innerHTML = `
        <button class="delete"></button>
        ${error.error || 'Failed to submit action. Please try again.'}
      `;

      const clockInMenu = document.getElementById('menu-clock-in');
      clockInMenu.insertBefore(errorBox, clockInMenu.firstChild);

      errorBox.querySelector('.delete').addEventListener('click', () => {
        errorBox.remove();
      });

      setTimeout(() => errorBox.remove(), 3000);
    });
});

document.getElementById("submitFollow").addEventListener("click", () => {
  const follower_id = followUser.value;
  const followed_id = followTarget.value;

  fetch("http://localhost:3000/api/v1/follows", {
    method: "POST",
    body: JSON.stringify({ follower_id, followed_id }),
    headers: { "Content-Type": "application/json" },
  })
  .then(response => {
    if (!response.ok) {
      // If the response wasn't ok (status 200-299), throw the response
      return response.json().then(err => Promise.reject(err));
    }
    return response.json();
  })
  .then(data => {
    // Success case
    const successBox = document.createElement('div');
    successBox.className = 'notification is-success is-light';
    successBox.innerHTML = `
      <button class="delete"></button>
      Successfully followed the user!
    `;

    // Insert the alert before the form
    const followMenu = document.getElementById('menu-follow');
    followMenu.insertBefore(successBox, followMenu.firstChild);

    // Add click handler to close button
    successBox.querySelector('.delete').addEventListener('click', () => {
      successBox.remove();
    });

    // Auto remove after 3 seconds
    setTimeout(() => successBox.remove(), 3000);
  })
  .catch(error => {
    // Error case
    const errorBox = document.createElement('div');
    errorBox.className = 'notification is-danger is-light';
    errorBox.innerHTML = `
      <button class="delete"></button>
      ${error.error || 'Failed to follow user. Please try again.'}
    `;

    // Insert the alert before the form
    const followMenu = document.getElementById('menu-follow');
    followMenu.insertBefore(errorBox, followMenu.firstChild);

    // Add click handler to close button
    errorBox.querySelector('.delete').addEventListener('click', () => {
      errorBox.remove();
    });

    // Auto remove after 3 seconds
    setTimeout(() => errorBox.remove(), 3000);
  });
});

loadTimelineButton.addEventListener("click", () => {
  selectedTimelineUser = timelineUser.value;
  if (selectedTimelineUser) {
    timelinePage = 1;
    fetchTimeline(selectedTimelineUser, true);
  }
});

loadMoreTimelineButton.addEventListener("click", () => {
  if (selectedTimelineUser) {
    timelinePage++;
    fetchTimeline(selectedTimelineUser, false);
  }
});

// Fetch Data Functions
function fetchUsers() {
  fetch("http://localhost:3000/api/v1/users")
    .then((response) => response.json())
    .then((data) => {
      const users = data.map((user) => ({ value: user.id, label: user.name }));
      [clockInUser, followUser, followTarget, timelineUser].forEach((select) =>
        populateOptions(select, users)
      );
    });
}

function fetchTimeline(userId, resetContent = false) {
  fetch(`http://localhost:3000/api/v1/users/${userId}/timeline?page=${timelinePage}&per=10`)
    .then((response) => response.json())
    .then((response) => {
      if (resetContent) {
        timelineContent.innerHTML = "";
      }

      if (response.data.length > 0) {
        response.data.forEach(item => {
          // Make sure we're working with an integer
          const totalSeconds = parseInt(item.attributes.duration_in_second);

          // Calculate hours, minutes, and remaining seconds
          const hours = Math.floor(totalSeconds / 3600);
          const minutes = Math.floor((totalSeconds % 3600) / 60);
          const seconds = Math.floor(totalSeconds % 60);

          // Create the duration string with all parts
          const durationString = `${hours} hour${hours !== 1 ? 's' : ''} ${minutes} minute${minutes !== 1 ? 's' : ''} ${seconds} second${seconds !== 1 ? 's' : ''}`;

          const date = new Date(item.attributes.created_at).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
          });

          const message = document.createElement('div');
          message.className = 'box mb-3';
          message.innerHTML = `${item.attributes.user_display_name} has been sleep for ${durationString} at ${date}`;
          timelineContent.appendChild(message);
        });

        if (response.meta.pagination.current_page < response.meta.pagination.total_pages) {
          loadMoreTimelineButton.classList.remove("is-hidden");
        } else {
          loadMoreTimelineButton.classList.add("is-hidden");
        }
      } else {
        loadMoreTimelineButton.classList.add("is-hidden");
      }
    })
    .catch(error => {
      const errorBox = document.createElement('div');
      errorBox.className = 'notification is-danger is-light';
      errorBox.innerHTML = `
        <button class="delete"></button>
        Failed to load timeline. Please try again.
      `;

      timelineContent.insertBefore(errorBox, timelineContent.firstChild);

      errorBox.querySelector('.delete').addEventListener('click', () => {
        errorBox.remove();
      });

      setTimeout(() => errorBox.remove(), 3000);
    });
}

// Initialize App
fetchUsers();
