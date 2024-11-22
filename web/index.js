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
  const user = clockInUser.value;
  const action = clockInAction.value;

  fetch("https://dummyapi.com/clockin", {
    method: "POST",
    body: JSON.stringify({ user, action }),
    headers: { "Content-Type": "application/json" },
  })
    .then((response) => response.json())
    .then((data) => {
      clockInTableBody.innerHTML = data
        .map(
          (item, index) =>
            `<tr>
              <td>${index + 1}</td>
              <td>${item.actionName}</td>
              <td>${item.time}</td>
            </tr>`
        )
        .join("");
    });
});

document.getElementById("submitFollow").addEventListener("click", () => {
  const user = followUser.value;
  const target = followTarget.value;

  fetch("https://dummyapi.com/follow", {
    method: "POST",
    body: JSON.stringify({ user, target }),
    headers: { "Content-Type": "application/json" },
  }).then(() => alert("Follow action submitted"));
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
  fetch("http://localhost:3002/api/v1/users")
    .then((response) => response.json())
    .then((data) => {
      const users = data.map((user) => ({ value: user.id, label: user.name }));
      [clockInUser, followUser, followTarget, timelineUser].forEach((select) =>
        populateOptions(select, users)
      );
    });
}

function fetchTimeline(userId, resetContent = false) {
  fetch(`http://localhost:3002/api/v1/users/${userId}/timeline?page=${timelinePage}&per=10`)
    .then((response) => response.json())
    .then((data) => {
      if (resetContent) {
        timelineContent.innerHTML = ""; // Clear previous content
      }
      if (data.length > 0) {
        timelineContent.innerHTML += data
          .map((item) => `<p>${item.user_display_name}</p>`)
          .join("");
        loadMoreTimelineButton.classList.remove("is-hidden");
      } else {
        loadMoreTimelineButton.classList.add("is-hidden");
      }
    });
}

// Initialize App
fetchUsers();
