// Parse ID from URL
const urlParams = new URLSearchParams(window.location.search);
const ministerId = urlParams.get('id');

if (ministerId) {
  fetch(`https://civiclink-backend-g3.onrender.com/api/v1/officials/${ministerId}`)
    .then(res => res.json())
    .then(data => {
      const minister = data.data;

      // Fill in the sections
      document.querySelector("#minister-avatar").src = minister.category.image || './images/Ellipse 1.png'; // fake avatar

      document.querySelector("#section_1 h1").textContent = minister.name;
      document.querySelector("#section_1 p").textContent = `${minister.level} Minister for ${minister.position}, Nigeria`;
      document.querySelector("#section_1 .im").style.display = minister.verified ? "inline" : "none";

      document.querySelector("#sec_2 p").textContent = minister.description;

      const contactInfo = {
        phone: minister.phone || "+234 000 000 0000",
        email: minister.email || "example@email.com",
        website: minister.website || "example.gov.ng",
        address: minister.address || "Not Available"
      };

      const contactDivs = document.querySelectorAll("#sec_3 .flex > div");
      contactDivs[0].lastElementChild.textContent = contactInfo.phone;
      contactDivs[1].lastElementChild.textContent = contactInfo.email;
      contactDivs[2].lastElementChild.textContent = contactInfo.website;
      contactDivs[3].lastElementChild.innerHTML = contactInfo.address.replace("\n", "<br>");
    })
    .catch(err => {
      console.error("Error fetching minister info:", err);
    });
} else {
  console.error("No minister ID found in URL");
}