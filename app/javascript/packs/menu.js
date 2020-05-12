function get_menu_json() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            var menu_json = JSON.parse(this.responseText);
            addcart(menu_json);
        }
    };
    xhttp.open("GET", "/menuitems/new", true);
    xhttp.send();
}

function addcart(menu_json) {
    let add_cart = document.querySelectorAll('.add-cart');
    for (let i = 0; i < add_cart.length; i++) {
        add_cart[i].addEventListener('click', () => {
            cartNumber(menu_json[i]);
        })
    }
}

function cartNumber(item) {

    let itemNumber = localStorage.getItem('cartNumber');
    itemNumber = parseInt(itemNumber);

    if (itemNumber) {
        localStorage.setItem('cartNumber', itemNumber + 1);
        document.querySelector('.cart-number').innerHTML = itemNumber + 1;
    } else {
        localStorage.setItem('cartNumber', 1);
        document.querySelector('.cart-number').innerHTML = 1;
    }
    itemList(item);
}


function itemList(item) {
    let item_list = localStorage.getItem('itemList');
    if (item_list) {
        var incartNumber = 0;
        item_list = JSON.parse(item_list);
        for (let i = 0; i < item_list.length; i++) {
            if (item_list[i].id === item.id) {
                item_list[i].incart += 1;
                incartNumber = 1;
            }
        }
        if (incartNumber === 0) {
            item.incart = 1;
            item_list.push(item);
        }
        console.log(item_list);
        localStorage.setItem('itemList', JSON.stringify(item_list));

    } else {
        var items = [];
        item["incart"] = 1;
        items.push(item);
        localStorage.setItem('itemList', JSON.stringify(items));
    }
}


function displayItems() {
    let items = localStorage.getItem('itemList');
    items = JSON.parse(items);
    let itemContainer = document.querySelector('.cart-box-items');
    if (items && itemContainer) {
        itemContainer.innerHTML = '';
        Object.values(items).map(item => {
            itemContainer.innerHTML += `
            <div class="cart-box-item-sec">
            <button class="cancel-icon"><i class="far fa-times-circle "></i></button>
            <p class="cart-box-item-para" >${item.item_name}</p>
            <p class="cart-box-item-price"><i class="fas fa-rupee-sign"></i> ${item.price}</p>
            <div class="cart-box-item-quantity">
              <button class="quantity-icon"><i class="fas fa-minus-circle"></i></button>
              <p class="cart-box-item-quantity-number">${item.incart}</p>
              <button class="quantity-icon"><i class="fas fa-plus-circle"></i></button>
            </div>
            <p class="cart-box-item-total">${item.price * item.incart}</p>
          </div>
          `
        })
    }

}

function onloadcartNumber() {
    let itemNumber = localStorage.getItem('cartNumber');
    let cartNumberContainer = document.querySelector('.cart-number')
    if (itemNumber && cartNumberContainer) {
        cartNumberContainer.innerHTML = itemNumber;
    }
}

get_menu_json()
onloadcartNumber()
displayItems()