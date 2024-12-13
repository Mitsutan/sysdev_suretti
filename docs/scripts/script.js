const sys_theme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';

document.documentElement.setAttribute('data-bs-theme', sys_theme);

function toggleTheme() {
    const theme = document.documentElement.getAttribute('data-bs-theme') === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-bs-theme', theme);
}
