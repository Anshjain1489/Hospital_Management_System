<%-- Shared Footer Include — closes main content wrapper, adds toast JS and dark mode --%>

</main><!-- end .main-content -->

<!-- Toast Container -->
<div id="toast-container"></div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
// ===== Dark Mode (persists via localStorage) =====
(function () {
    const saved = localStorage.getItem('hms-dark');
    if (saved === 'true') {
        document.body.classList.add('dark-mode');
        const btn = document.getElementById('darkToggle');
        if (btn) btn.textContent = '☀️';
    }
})();

function toggleDark() {
    document.body.classList.toggle('dark-mode');
    const isDark = document.body.classList.contains('dark-mode');
    localStorage.setItem('hms-dark', isDark);
    const btn = document.getElementById('darkToggle');
    if (btn) btn.textContent = isDark ? '☀️' : '🌙';
}

// ===== Responsive Sidebar =====
function toggleSidebar() {
    const s = document.getElementById('sidebar');
    const o = document.getElementById('sidebarOverlay');
    s.classList.toggle('open');
    o.classList.toggle('show');
}
function closeSidebar() {
    document.getElementById('sidebar').classList.remove('open');
    document.getElementById('sidebarOverlay').classList.remove('show');
}

// ===== Toast Notifications =====
function showToast(message, type) {
    const icons = { success: '✅', danger: '❌', warning: '⚠️', info: 'ℹ️' };
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = 'toast ' + (type || 'info');
    toast.innerHTML = \`
        <span class="toast-icon">\${icons[type] || 'ℹ️'}</span>
        <span class="toast-msg">\${message}</span>
        <button class="toast-close" onclick="this.parentElement.remove()">✕</button>
    \`;
    container.appendChild(toast);
    setTimeout(() => toast.style.opacity = '0', 4000);
    setTimeout(() => toast.remove(), 4500);
}

// ===== Read URL params and show toasts =====
(function () {
    const params = new URLSearchParams(window.location.search);
    const msg  = params.get('msg');
    const type = params.get('type');
    if (msg) {
        showToast(decodeURIComponent(msg.replace(/\+/g, ' ')), type || 'info');
        // Clean URL without reload
        const url = new URL(window.location);
        url.searchParams.delete('msg');
        url.searchParams.delete('type');
        window.history.replaceState({}, '', url);
    }
})();

// ===== Live Search Filter for tables =====
function filterTable(inputId, tableId) {
    const input = document.getElementById(inputId);
    if (!input) return;
    input.addEventListener('input', function () {
        const q = this.value.toLowerCase();
        const rows = document.querySelectorAll('#' + tableId + ' tbody tr');
        rows.forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    });
}

// ===== Confirm Delete =====
function confirmDelete(url, name) {
    if (confirm('Delete ' + name + '? This action cannot be undone.')) {
        window.location.href = url;
    }
}
</script>

</body>
</html>
