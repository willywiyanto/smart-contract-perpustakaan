// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Perpustakaan {
    address public pemilik;
    address public admin;

    struct Buku {
        uint256 ISBN;
        string judul;
        uint256 tahun;
        string penulis;
    }
    mapping(uint256 => Buku) public buku;
    uint256 public jumlahBuku;

    constructor() {
        pemilik = msg.sender;
        admin = msg.sender;
    }

    modifier hanyaAdmin() {
        require(msg.sender == admin, "Hanya admin yang dapat melakukan tindakan ini");
        _;
    }

    modifier hanyaPemilik() {
        require(msg.sender == pemilik, "Hanya pemilik yang dapat melakukan tindakan ini");
        _;
    }

    event BukuDitambahkan(uint256 indexed ISBN, string judul, uint256 tahun, string penulis);
    event BukuDiperbarui(uint256 indexed ISBN, string judul, uint256 tahun, string penulis);
    event BukuDihapus(uint256 indexed ISBN);

    function TambahBuku(uint256 _ISBN, string memory _judul, uint256 _tahun, string memory _penulis) public hanyaAdmin {
        require(buku[_ISBN].ISBN == 0, "Buku dengan ISBN yang sama sudah ada");
        buku[_ISBN] = Buku(_ISBN, _judul, _tahun, _penulis);
        jumlahBuku++;
        emit BukuDitambahkan(_ISBN, _judul, _tahun, _penulis);
    }

    function PerbaruiBuku(uint256 _ISBN, string memory _judul, uint256 _tahun, string memory _penulis) public hanyaAdmin {
        require(buku[_ISBN].ISBN != 0, "Buku dengan ISBN yang ditentukan tidak ada");
        buku[_ISBN] = Buku(_ISBN, _judul, _tahun, _penulis);
        emit BukuDiperbarui(_ISBN, _judul, _tahun, _penulis);
    }

    function HapusBuku(uint256 _ISBN) public hanyaAdmin {
        require(buku[_ISBN].ISBN != 0, "Buku dengan ISBN yang ditentukan tidak ada");
        delete buku[_ISBN];
        jumlahBuku--;
        emit BukuDihapus(_ISBN);
    }

    function DapatkanBuku(uint256 _ISBN, address pemanggil) public view returns (uint256, string memory, uint256, string memory) {
        require(buku[_ISBN].ISBN != 0, "Buku dengan ISBN yang ditentukan tidak ada");
        require(pemanggil == admin || pemanggil == pemilik, "Hanya admin dan pemilik yang dapat mengakses fungsi ini");
        Buku memory bukuData = buku[_ISBN];
        return (bukuData.ISBN, bukuData.judul, bukuData.tahun, bukuData.penulis);
    }
    
    function isAdmin(address _alamat) public view returns (bool) {
        return (_alamat == admin);
    }
}