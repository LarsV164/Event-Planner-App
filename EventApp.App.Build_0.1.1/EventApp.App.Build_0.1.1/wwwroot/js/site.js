// JavaScript-code voor het filteren van evenementen op basis van prijs.
// Dit javascript zorgt ervoor dat er geen knop nodig is om de filter toe te passen, de pagina wordt herhalen wanneer de gebruiker de filter aanpast.

//console.log("site.js is geladen");

document.addEventListener("DOMContentLoaded", function () {

    // Haal de invoervelden voor de minimum- en maximumprijs op.
    const minimumPrijsInput = document.getElementById("min-input");
    const maximumPrijsInput = document.getElementById("max-input");

    // Haal de schuifregelaars voor de minimum- en maximumprijs op.
    const minimumPrijsSlider = document.querySelector(".min-range");
    const maximumPrijsSlider = document.querySelector(".max-range");

    // Controleer of alle benodigde elementen bestaan.
    if (
        !minimumPrijsInput ||
        !maximumPrijsInput ||
        !minimumPrijsSlider ||
        !maximumPrijsSlider
    ) {
        return;
    }

    // Stel de laagste en hoogste toegestane prijs in.
    const laagstePrijs = 0;
    const hoogstePrijs = 2200;

    // Werk de prijsvelden en schuifregelaars bij.
    function synchroniseerPrijzen(bron) {

        // Lees de huidige waarden uit de invoervelden.
        let minimumPrijs = Number(minimumPrijsInput.value);
        let maximumPrijs = Number(maximumPrijsInput.value);

        // Gebruik de waarde van de schuifregelaar als die is aangepast.
        if (bron === "minimum-slider") {
            minimumPrijs = Number(minimumPrijsSlider.value);
        }

        if (bron === "maximum-slider") {
            maximumPrijs = Number(maximumPrijsSlider.value);
        }

        // Zorg ervoor dat de prijzen binnen het toegestane bereik vallen.
        minimumPrijs = Math.max(
            laagstePrijs,
            Math.min(hoogstePrijs, minimumPrijs)
        );

        maximumPrijs = Math.max(
            laagstePrijs,
            Math.min(hoogstePrijs, maximumPrijs)
        );

        // Voorkom dat de minimumprijs hoger wordt dan de maximumprijs.
        if (minimumPrijs > maximumPrijs) {

            if (
                bron === "minimum-input" ||
                bron === "minimum-slider"
            ) {
                minimumPrijs = maximumPrijs;
            } else {
                maximumPrijs = minimumPrijs;
            }
        }

        // Toon de bijgewerkte prijzen in de invoervelden.
        minimumPrijsInput.value = minimumPrijs;
        maximumPrijsInput.value = maximumPrijs;

        // Laat de schuifregelaars dezelfde prijzen weergeven.
        minimumPrijsSlider.value = minimumPrijs;
        maximumPrijsSlider.value = maximumPrijs;
    }

    // Pas de prijsfilter toe door de pagina opnieuw te laden.
    function pasPrijsfilterToe() {

        // Bewaar bestaande URL-parameters, zoals andere filters.
        const urlParameters = new URLSearchParams(
            window.location.search
        );

        // Voeg de gekozen minimum- en maximumprijs toe.
        urlParameters.set(
            "minPrice",
            minimumPrijsInput.value
        );

        urlParameters.set(
            "maxPrice",
            maximumPrijsInput.value
        );

        // Bouw de URL op met de nieuwe prijswaarden.
        const nieuweUrl =
            window.location.pathname +
            "?" +
            urlParameters.toString();

        // Laad de pagina opnieuw zodat OnGetAsync de filter toepast.
        window.location.href = nieuweUrl;
    }

    // Synchroniseer de prijzen wanneer de minimumprijs wordt aangepast.
    minimumPrijsInput.addEventListener("input", function () {
        synchroniseerPrijzen("minimum-input");
    });

    // Synchroniseer de prijzen wanneer de maximumprijs wordt aangepast.
    maximumPrijsInput.addEventListener("input", function () {
        synchroniseerPrijzen("maximum-input");
    });

    // Synchroniseer de prijzen wanneer de minimumslider wordt verschoven.
    minimumPrijsSlider.addEventListener("input", function () {
        synchroniseerPrijzen("minimum-slider");
    });

    // Synchroniseer de prijzen wanneer de maximumslider wordt verschoven.
    maximumPrijsSlider.addEventListener("input", function () {
        synchroniseerPrijzen("maximum-slider");
    });

    // Pas de filter toe zodra de minimumprijs is aangepast.
    minimumPrijsInput.addEventListener("change", function () {
        synchroniseerPrijzen("minimum-input");
        pasPrijsfilterToe();
    });

    // Pas de filter toe zodra de maximumprijs is aangepast.
    maximumPrijsInput.addEventListener("change", function () {
        synchroniseerPrijzen("maximum-input");
        pasPrijsfilterToe();
    });

    // Pas de filter toe zodra de minimumslider wordt losgelaten.
    minimumPrijsSlider.addEventListener("change", function () {
        synchroniseerPrijzen("minimum-slider");
        pasPrijsfilterToe();
    });

    // Pas de filter toe zodra de maximumslider wordt losgelaten.
    maximumPrijsSlider.addEventListener("change", function () {
        synchroniseerPrijzen("maximum-slider");
        pasPrijsfilterToe();
    });


    // review filter 
    const reviewRadios = document.querySelectorAll(
        'input[name="minRating"]'
    );

    console.log("Aantal reviewknoppen:", reviewRadios.length);

    reviewRadios.forEach(function (radio) {
        radio.addEventListener("change", function () {
            const urlParameters = new URLSearchParams(
                window.location.search
            );

            // Verwijder de reviewfilter als Alles is gekozen.
            if (this.value === "0") {
                urlParameters.delete("minRating");

            } else {
                // Stel de gekozen minimumscore in.
                urlParameters.set("minRating", this.value);
            }

            const queryString = urlParameters.toString();

            window.location.href =
                window.location.pathname +
                (queryString ? "?" + queryString : "");
        });
    });
    // 18+-filter
    const adultsOnlyCheckbox = document.getElementById(
        "adults-only-checkbox"
    );

    if (adultsOnlyCheckbox) {
        adultsOnlyCheckbox.addEventListener("change", function () {
            const urlParameters = new URLSearchParams(
                window.location.search
            );

            if (this.checked) {
                urlParameters.set("adultsOnly", "true");
            } else {
                urlParameters.delete("adultsOnly");
            }

            const queryString = urlParameters.toString();

            window.location.href =
                window.location.pathname +
                (queryString ? "?" + queryString : "");
        });
    }

});