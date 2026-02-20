//
//  main.swift
//  Week2LouisYuriel
//
//  Created by student on 20/02/26.
//

import Foundation

let menuTuku = [
    Menu(name: "Tahu Isi", price: 6000),
    Menu(name: "Nasi Kuning", price: 18000),
    Menu(name: "Nasi Campur", price: 24000),
    Menu(name: "Air Mineral", price: 4000),
]
let menuGotri = [
    Menu(name: "Soto Ayam", price: 15000),
    Menu(name: "Nasi Putih", price: 5000),
]
let menuMadam = [
    Menu(name: "Ayam Geprek", price: 30000),
    Menu(name: "Ayam Goreng", price: 27000),
]
let menuKopte = [
    Menu(name: "Nasi Goreng", price: 18000), Menu(name: "Satay", price: 22000),
]

let listResto = [
    Resto(name: "Tuku-Tuku", menus: menuTuku),
    Resto(name: "Gotri", menus: menuGotri),
    Resto(name: "Madam Lie", menus: menuMadam),
    Resto(name: "Kopte", menus: menuKopte),
]

var cart: [cartItem] = []
var isRunning = true

while isRunning {
    print("WELCOME TO UC-WALK CAFETERIA !")
    print("Please choose cafeteria")
    print(
        """
        [1] Tuku-Tuku
        [2] Gotri 
        [3] Madam Lie
        [4] Kopte
        --
        [S]hopping Cart
        [Q]uit

        Your cafeteria choice?
        """
    )

    if let input = readLine() {
        switch input.lowercased() {
        case "q":
            print("Quitting")
            isRunning = false

        case "s":
            var isViewingCart = true

            while isViewingCart {
                if cart.isEmpty {
                    print("Keranjang kamu kosong")
                    isViewingCart = false
                } else {
                    print("--- Isi Keranjang Belanja ---")
                    var grandtotal = 0
                    let groupedCart = Dictionary(
                        grouping: cart,
                        by: { $0.restoName }
                    )

                    for (resto, items) in groupedCart {
                        print("Resto Name: \(resto)")

                        for item in items {
                            let subTotal = item.quantity * item.price
                            print(
                                "- \(item.name) (x\(item.quantity)): Rp\(subTotal)"
                            )
                            grandtotal += subTotal
                        }
                    }
                    print("Grand Total = \(grandtotal)")

                    print("Press [B] to go back")
                    print("Press [P] to pay / checkout")
                    print("Press [E] to edit / delete")
                    print("Your choice? ")

                    if let cartChoice = readLine() {
                        switch cartChoice.lowercased() {
                        case "b":
                            isViewingCart = false
                        case "e":
                            print("---Edit cart---")
                            for (index, item) in cart.enumerated() {
                                print(
                                    "[\(index + 1)] \(item.name) (x\(item.quantity)) - \(item.restoName)"
                                )
                            }
                            print(
                                "Enter the number of the item you want to edit (or 0 to cancel): "
                            )

                            if let editInput = readLine(),
                                let editIndex = Int(editInput)
                            {
                                if editIndex > 0 && editIndex <= cart.count {
                                    let actualIndex = editIndex - 1
                                    let selectedItem = cart[actualIndex]

                                    print(
                                        "You selected: \(selectedItem.name) (Current qty: \(selectedItem.quantity))"
                                    )
                                    print(
                                        "Enter new quantity (Enter 0 to delete item): "

                                    )

                                    if let qtyInput = readLine(),
                                        let newQty = Int(qtyInput)
                                    {
                                        if newQty == 0 {
                                            cart.remove(at: actualIndex)
                                            print("Item removed from cart.")
                                        } else if newQty > 0 {
                                            cart[actualIndex].quantity = newQty
                                            print(
                                                "Quantity updated to \(newQty)."
                                            )
                                        } else {
                                            print(
                                                "Invalid quantity. Must be greater than 0"
                                            )
                                        }
                                    } else {
                                        print("Invalid Input")
                                    }
                                } else if editIndex == 0 {
                                    print("Edit Cancelled")
                                } else {
                                    print("Item Number not found")
                                }
                            } else {
                                print("Invalid input")
                            }
                        case "p":
                            var finalTotal = grandtotal

                            print(
                                "Do you have a promo code? (Type code or press Enter to skip) (UCWALK20): "
                            )
                            if let promoInput = readLine() {
                                if promoInput.uppercased() == "UCWALK20" {
                                    let discount = finalTotal * 20 / 100
                                    finalTotal -= discount
                                    print(
                                        "Promo applied! You get a Rp\(discount) discount."
                                    )
                                    print("Your new total is Rp\(finalTotal)")
                                } else if !promoInput.isEmpty {
                                    print(
                                        "Invalid promo code. Proceeding with normal price."
                                    )
                                }
                            }

                            var isPaying = true
                            while isPaying {
                                print(
                                    "Enter the amount of your money: "

                                )
                                if let payInput = readLine(),
                                    let payment = Int(payInput)
                                {
                                    if payment == 0 {
                                        print("Payment can't be 0")
                                    } else if payment < 0 {
                                        print("Please enter a valid amount")
                                    } else if payment < finalTotal {
                                        print("Payment is not enough")
                                    } else {
                                        let change = payment - finalTotal
                                        print(
                                            "Transaksi berhasil, kembalian kamu adalah \(change)"
                                        )
                                        cart.removeAll()
                                        isPaying = false
                                        isViewingCart = false
                                    }
                                } else {
                                    print("Please enter a valid amount")
                                }
                            }
                        default:
                            print("Invalid input")
                        }
                    }
                }
            }

        default:
            if let number = Int(input) {
                if number > 0 && number <= listResto.count {
                    let selectedResto = listResto[number - 1]
                    print("Anda memilih: \(selectedResto.name)")
                    selectedResto.displayMenu()

                    if let menuInput = readLine(),
                        let menuIndex = Int(menuInput)
                    {
                        if let chosenMenu = selectedResto.getMenuItem(
                            at: menuIndex - 1
                        ) {
                            print("Masukkan quantity:")
                            if let qty = readLine(), let quantity = Int(qty),
                                quantity > 0
                            {
                                if let index = cart.firstIndex(where: {
                                    $0.name == chosenMenu.name
                                        && $0.restoName == selectedResto.name
                                }) {
                                    cart[index].quantity += quantity
                                    print(
                                        "Berhasil menambah quantity \(chosenMenu.name) di cart"
                                    )
                                } else {
                                    let newItem = cartItem(
                                        restoName: selectedResto.name,
                                        name: chosenMenu.name,
                                        price: chosenMenu.price,
                                        quantity: quantity
                                    )
                                    cart.append(newItem)
                                    print(
                                        "Berhasil memasukan: \(chosenMenu.name) ke dalam cart"
                                    )
                                }
                            } else {
                                print("Quantity tidak valid")
                            }
                        } else {
                            print("Menu tidak tersedia")
                        }
                    } else {
                        print("Input menu tidak valid")
                    }
                } else {
                    print("Nomor resto tidak tersedia")
                }
            } else {
                print("Input salah. Masukan angka atau q/s")
            }
        }
    }
}
