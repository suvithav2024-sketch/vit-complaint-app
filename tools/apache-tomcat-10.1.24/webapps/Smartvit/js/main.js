/**
 * SMART VIT - Student Complaint Management System
 * Core Client-side Scripts
 */

document.addEventListener('DOMContentLoaded', function () {

    // 1. Dynamic Category -> Subcategory Dropdown Loader
    const categorySelect = document.getElementById('categorySelect');
    const subcategorySelect = document.getElementById('subcategorySelect');

    if (categorySelect && subcategorySelect) {
        categorySelect.addEventListener('change', function () {
            const catId = this.value;
            subcategorySelect.innerHTML = '<option value="">Loading subcategories...</option>';
            subcategorySelect.disabled = true;

            if (!catId) {
                subcategorySelect.innerHTML = '<option value="">-- Select Category First --</option>';
                return;
            }

            const contextPath = getContextPath();
            fetch(`${contextPath}/api/subcategories?categoryId=${catId}`)
                .then(response => response.json())
                .then(data => {
                    subcategorySelect.innerHTML = '<option value="">-- Select Subcategory --</option>';
                    if (data && data.length > 0) {
                        data.forEach(item => {
                            const opt = document.createElement('option');
                            opt.value = item.subcategoryId;
                            opt.textContent = item.name + (item.defaultPriority ? ` (${item.defaultPriority})` : '');
                            if (item.defaultPriority) {
                                opt.dataset.priority = item.defaultPriority;
                            }
                            subcategorySelect.appendChild(opt);
                        });
                        subcategorySelect.disabled = false;
                    } else {
                        subcategorySelect.innerHTML = '<option value="">No subcategories found</option>';
                    }
                })
                .catch(err => {
                    console.error('Failed to load subcategories:', err);
                    subcategorySelect.innerHTML = '<option value="">Error loading subcategories</option>';
                });
        });

        // If category is already selected on page load (e.g. edit or validation error)
        if (categorySelect.value && subcategorySelect.options.length <= 1) {
            categorySelect.dispatchEvent(new Event('change'));
        }

        // Auto update priority suggestion if defaultPriority is present
        subcategorySelect.addEventListener('change', function () {
            const selectedOpt = this.options[this.selectedIndex];
            const prioritySelect = document.getElementById('prioritySelect');
            if (prioritySelect && selectedOpt && selectedOpt.dataset.priority) {
                prioritySelect.value = selectedOpt.dataset.priority;
            }
        });
    }

    // 2. Dynamic Building -> Location Dropdown Loader (when not locked by QR code)
    const buildingSelect = document.getElementById('buildingSelect');
    const locationSelect = document.getElementById('locationSelect');

    if (buildingSelect && locationSelect && !locationSelect.disabled) {
        buildingSelect.addEventListener('change', function () {
            const bldgId = this.value;
            locationSelect.innerHTML = '<option value="">Loading rooms...</option>';
            locationSelect.disabled = true;

            if (!bldgId) {
                locationSelect.innerHTML = '<option value="">-- Select Building First --</option>';
                return;
            }

            const contextPath = getContextPath();
            fetch(`${contextPath}/api/locations?buildingId=${bldgId}`)
                .then(response => response.json())
                .then(data => {
                    locationSelect.innerHTML = '<option value="">-- Select Room / Location --</option>';
                    if (data && data.length > 0) {
                        data.forEach(loc => {
                            const opt = document.createElement('option');
                            opt.value = loc.locationId;
                            opt.textContent = `Room ${loc.roomNumber} (Floor ${loc.floor}${loc.block ? ', ' + loc.block : ''})${loc.locationName ? ' - ' + loc.locationName : ''}`;
                            locationSelect.appendChild(opt);
                        });
                        locationSelect.disabled = false;
                    } else {
                        locationSelect.innerHTML = '<option value="">No registered locations in building</option>';
                    }
                })
                .catch(err => {
                    console.error('Failed to load locations:', err);
                    locationSelect.innerHTML = '<option value="">Error loading rooms</option>';
                });
        });
    }

    // 3. Quick Complaint Tracker on Landing Page
    const trackBtn = document.getElementById('trackComplaintBtn');
    const trackInput = document.getElementById('trackComplaintInput');
    const trackResultDiv = document.getElementById('trackResultArea');

    if (trackBtn && trackInput && trackResultDiv) {
        trackBtn.addEventListener('click', function () {
            const code = trackInput.value.trim();
            if (!code) {
                trackResultDiv.innerHTML = '<div class="alert alert-warning py-2 mb-0">Please enter a valid Complaint ID.</div>';
                return;
            }

            trackResultDiv.innerHTML = '<div class="text-center py-2"><span class="spinner-border spinner-border-sm text-primary"></span> Searching record...</div>';

            const contextPath = getContextPath();
            fetch(`${contextPath}/api/track-public?code=${encodeURIComponent(code)}`)
                .then(res => res.json())
                .then(data => {
                    if (data.found) {
                        trackResultDiv.innerHTML = `
                            <div class="card border-primary mt-3 shadow-sm text-dark">
                                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                                    <strong>${data.code}</strong>
                                    <span class="badge bg-light text-primary font-monospace">${data.status}</span>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title">${data.title}</h6>
                                    <div class="row g-2 small mb-2 text-muted">
                                        <div class="col-6"><strong>Category:</strong> ${data.category}</div>
                                        <div class="col-6"><strong>Department:</strong> ${data.department}</div>
                                        <div class="col-6"><strong>Priority:</strong> <span class="badge bg-secondary">${data.priority}</span></div>
                                        <div class="col-6"><strong>Submitted:</strong> ${data.date ? data.date.substring(0, 10) : 'N/A'}</div>
                                    </div>
                                    ${data.resolution ? `<div class="p-2 bg-light rounded small border"><strong>Resolution:</strong> ${data.resolution}</div>` : ''}
                                </div>
                            </div>
                        `;
                    } else {
                        trackResultDiv.innerHTML = `<div class="alert alert-danger py-2 mb-0 mt-2">No complaint found matching ID <strong>${code}</strong>. Please verify the code.</div>`;
                    }
                })
                .catch(err => {
                    trackResultDiv.innerHTML = '<div class="alert alert-danger py-2 mb-0 mt-2">Error communicating with server.</div>';
                });
        });
    }

    // 4. Mark Notification as Read (individual)
    document.querySelectorAll('.btn-mark-notif-read').forEach(button => {
        button.addEventListener('click', function (e) {
            e.preventDefault();
            const notifId = this.dataset.notifId;
            const container = document.getElementById(`notif-item-${notifId}`);
            const contextPath = getContextPath();

            fetch(`${contextPath}/notifications/read?id=${notifId}`, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.success && container) {
                        container.classList.remove('bg-light', 'border-primary');
                        container.classList.add('bg-white');
                        button.remove();
                    }
                });
        });
    });
});

// Helper to determine context path dynamically (e.g. /Smartvit or empty)
function getContextPath() {
    const path = window.location.pathname;
    const parts = path.split('/');
    if (parts.length > 1 && parts[1].length > 0 && !parts[1].includes('.')) {
        return '/' + parts[1];
    }
    return '';
}
