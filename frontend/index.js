fetch("https://civiclink-backend-g3.onrender.com/api/v1/officials")
  .then(res => res.json())
  .then(data => {
    const container = document.getElementById("minister-template");
    const template = document.getElementById("minister-section");

    // Remove template from the DOM
    template.remove();

    const info = data.data
    console.log(info[0]) 
    info.forEach(minister => {
      const clone = template.cloneNode(true);
    //   console.log(minister.name)

      // Fill in the data

      clone.querySelector("#minister-avatar").src = minister.category.image || './images/Ellipse 1.png'; // fake avatar
      clone.querySelector("#minister-name").textContent = minister.name;
      clone.querySelector("#minister-title").textContent = minister.position;
      clone.querySelector("#minister-description").textContent = minister.description;
    //   clone.querySelector("#minister-level-text").textContent = "Federal";
      clone.querySelector("#contact-link").href = `./directory.html?id=${minister._id}`;

      // Randomly set verification for demo
    //   if (Math.random() > 0.5) {
        // clone.querySelector(".verified-icon").style.display = "inline";
    //   }

      container.appendChild(clone);
    });
  })
  .catch(err => {
    console.error("Failed to load ministers:", err);
  });