function toggle_terms_accept() {
    const terms_checkbox = document.getElementById("terms_accepted");

    terms_checkbox.checked = !terms_checkbox.checked;
}

module.exports = {
    toggle_terms_accept
}

